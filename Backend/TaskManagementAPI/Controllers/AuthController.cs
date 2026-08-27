using BussinessLayer;
using DataAccessLayer.Data;
using DataAccessLayer.DTOs;
using DataAccessLayer.DTOs.Auth;
using DataAccessLayer.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;


namespace Controllers
{
    // This controller is responsible for authentication-related actions,
    // such as logging in and issuing JWT tokens.
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {

        private readonly ApplicationDbContext _context;

        private readonly IConfiguration _configuration;

        public AuthController(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }


        private string GenerateRefreshToken()
        {
            var bytes = new byte[64];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(bytes);
            return Convert.ToBase64String(bytes);
        }



        [HttpPost("SignUp")]
        [EnableRateLimiting("AuthLimiter")]
        public async Task<ActionResult> SignUp(SignUpDTO signupDTO)
        {
            if (signupDTO == null)
            {
                return BadRequest("Empty Data!");
            }

            bool success = await UserService.UserSignUpAsync(signupDTO, _context);

            if (success)
            {
                return Ok("The User Sign up Successfully");
            }

            return BadRequest("User already Exist try login to system");

        }



        // This endpoint handles user login.
        // It verifies credentials and returns a JWT token if login succeeds.
        [HttpPost("login")]
        [EnableRateLimiting("AuthLimiter")]
        public async Task<IActionResult> Login([FromBody] LoginRequestDTO request)
        {

            UserDTO? userDTO = await UserService.UserLoginAsync(request.EmailAddress, request.Password, _context);

            if (userDTO == null)
            {
                return Unauthorized("Invalid credentials");
            }



            var claims = new[]
            {
                // Unique identifier for the student
                new Claim(ClaimTypes.NameIdentifier, userDTO.user_id.ToString()),


                // Student email address
                new Claim(ClaimTypes.Email, userDTO.email_address),


                // Role (Student or Admin) used later for authorization
                new Claim(ClaimTypes.Role, userDTO.user_role)
            };


            // Step 4: Create the symmetric security key used to sign the JWT.
            // This key must match the key used in JWT validation middleware.
            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("JWT_SECRET")!));


            // Step 5: Define the signing credentials.
            // This specifies the algorithm used to sign the token.
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);



            // Step 6: Create the JWT token.
            // The token includes issuer, audience, claims, expiration, and signature.
            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"]!,
                audience: _configuration["Jwt:Audience"]!,
                claims: claims,
                expires: DateTime.Now.AddMinutes(30),
                signingCredentials: creds
            );


            var accessToken = new JwtSecurityTokenHandler().WriteToken(token);

            // Create refresh token (random)
            var refreshToken = GenerateRefreshToken();

            // Store refresh token securely (hash + expiry + not revoked)
            refresh_token RefreshToken = new refresh_token
            {
                user_id = userDTO.user_id,
                refresh_token_hash = BCrypt.Net.BCrypt.HashPassword(refreshToken),
                expires_at = DateTime.UtcNow.AddDays(7),
                revoked_at = null
            };

            await UserService.AddRefreshTokenAsync(RefreshToken, _context);

            return Ok(new TokenResponse
            {
                AccessToken = accessToken,
                RefreshToken = refreshToken
            });

        }


        [HttpPost("refresh")]
        [EnableRateLimiting("AuthLimiter")]
        public async Task<IActionResult> Refresh([FromBody] RefreshRequest request)
        {
            user? user = await UserService.FindUserUsingEmailAsync(request.Email, _context);

            if (user == null)
                return Unauthorized("Invalid refresh request");

            refresh_token? refrechTokenData = await UserService.FindRefreshTokenUsingUserIdAsync(user.user_id, _context);

            if (refrechTokenData == null)
                return Unauthorized("Invalid refresh request");


            if (refrechTokenData.revoked_at != null)
                return Unauthorized("Refresh token is revoked");

            if (refrechTokenData.expires_at == null || refrechTokenData.expires_at <= DateTime.UtcNow)
                return Unauthorized("Refresh token expired");

            bool refreshValid = BCrypt.Net.BCrypt.Verify(request.RefreshToken, refrechTokenData.refresh_token_hash);
            if (!refreshValid)
                return Unauthorized("Invalid refresh token");

            // Issue NEW access token (same claims & signing settings as login)
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.user_id.ToString()),
                new Claim(ClaimTypes.Email, user.email_address),
                new Claim(ClaimTypes.Role, user.user_role)
            };

            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(Environment.GetEnvironmentVariable("JWT_SECRET")!));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var jwt = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"]!,
                audience: _configuration["Jwt:Audience"]!,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(30),
                signingCredentials: creds
            );

            var newAccessToken = new JwtSecurityTokenHandler().WriteToken(jwt);

            // Rotation: replace refresh token
            var newRefreshToken = GenerateRefreshToken();

            await UserService.ReplaceRefreshTokenAsync(refrechTokenData, newRefreshToken, _context);

            return Ok(new TokenResponse
            {
                AccessToken = newAccessToken,
                RefreshToken = newRefreshToken
            });
        }


        [HttpPost("logout")]
        public async Task<IActionResult> Logout([FromBody] LogoutRequest request)
        {
            user? user = await UserService.FindUserUsingEmailAsync(request.Email, _context);

            if (user == null)
                return Ok(); // Do not reveal if user exists


            refresh_token? refrechTokenData = await UserService.FindRefreshTokenUsingUserIdAsync(user.user_id, _context);

            if (refrechTokenData == null)
                return Ok(); // Do not reveal if user exists


            bool refreshValid = BCrypt.Net.BCrypt.Verify(request.RefreshToken, refrechTokenData.refresh_token_hash);
            if (!refreshValid)
                return Ok();



            await UserService.DeleteRefreshTokenAsync(refrechTokenData.refresh_token_id, _context);


            return Ok("Logged out successfully");
        }


    }
}