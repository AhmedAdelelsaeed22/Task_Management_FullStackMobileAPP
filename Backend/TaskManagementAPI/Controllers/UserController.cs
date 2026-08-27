using BussinessLayer;
using DataAccessLayer.Data;
using DataAccessLayer.DTOs;
using DataAccessLayer.Utilities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace TaskManagementAPI.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : Controller
    {

        private readonly ApplicationDbContext _context;

        public UserController(ApplicationDbContext context)
        {
            _context = context;
        }




        [Authorize(Roles = "Admin")]
        [HttpGet("GetAll", Name = "GetAllUsers")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]

        public async Task<ActionResult<IEnumerable<UserDTO>>> GetAllUsers()
        {
            List<UserDTO> users = await UserService.GetAllUsersAsync(_context);

            if (users.Count == 0)
            {
                return NotFound("Not Found Any Users");
            }

            return Ok(users);
        }

        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [HttpGet("{id}", Name = "GetUserById")]
        public async Task<ActionResult<UserDTO>> GetUserById(int id, [FromServices] IAuthorizationService authorizationService)
        {

            if (id < 1)
                return BadRequest("Invalid student id.");



            UserService? user = await UserService.FindAsync(id, _context);



            if (user == null)
                return NotFound("Student not found.");



            var authResult = await authorizationService.AuthorizeAsync(
             User,
             id,
             "UserOwnerOrAdmin");

            if (!authResult.Succeeded)
                return Forbid(); // 403


            return Ok(user.UDTO);
        }



        [Authorize(Roles = "Admin")]
        [HttpPost("InsertNewUser", Name = "InsertNewUser")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<UserDTO>> InsertNewUser(UserDTO NewUserDTO)
        {
            if (NewUserDTO == null || !EmailValidating.IsValidEmail(NewUserDTO.email_address))
            {
                return BadRequest("Invalid Data");
            }

            UserService userInfo = new UserService
                (NewUserDTO);
            await userInfo.Save(_context);


            NewUserDTO.user_id = userInfo.user_id;

            return CreatedAtRoute("GetUserById", new { Id = NewUserDTO.user_id }, NewUserDTO);
        }


        private static void _UpdateNewData(UserDTO NewUserData, UserService OldDataBeforeUpdated)
        {
            OldDataBeforeUpdated.full_name = NewUserData.full_name;
            OldDataBeforeUpdated.user_name = NewUserData.user_name;
            OldDataBeforeUpdated.email_address = NewUserData.email_address;
            OldDataBeforeUpdated.password = NewUserData.password;
            OldDataBeforeUpdated.job_title = NewUserData.job_title;
            OldDataBeforeUpdated.time_zone = NewUserData.time_zone;
            OldDataBeforeUpdated.account_status = NewUserData.account_status;
            OldDataBeforeUpdated.date_created = NewUserData.date_created;
            OldDataBeforeUpdated.last_login_date = NewUserData.last_login_date;
            OldDataBeforeUpdated.user_role = NewUserData.user_role;
        }



        [HttpPut("updateUserData/{UserId}", Name = "UpdateUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<UserDTO>> UpdateUser(UserDTO newUserInfo, int UserId, [FromServices] IAuthorizationService authorizationService)
        {
            if (UserId < 0)
            {
                return BadRequest("Invalid Data or Invalid ID");
            }


            var authResult = await authorizationService.AuthorizeAsync(
            User,
            UserId,
            "UserOwnerOrAdmin");

            if (!authResult.Succeeded)
                return Forbid(); // 403


            UserService? UserInfo = await UserService.FindAsync(UserId, _context);

            if (UserInfo == null)
            {
                return NotFound("Not Found this User");
            }



            _UpdateNewData(newUserInfo, UserInfo);

            if (!EmailValidating.IsValidEmail(UserInfo.email_address))
            {
                return BadRequest("Invalid Email Address");
            }

            await UserInfo.Save(_context);

            return Ok(UserInfo.UDTO);
        }




        [HttpGet("GetUserId/{email}", Name = "GetUserId")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<int>> GetUserIdUsingEmail(string email)
        {

            int? UserId = await UserService.GetUserIdUsingEmailAsync(email, _context);

            if (UserId == null)
            {
                return BadRequest("Invalid Email");
            }


            return Ok(UserId);
        }






        [Authorize(Roles = "Admin")]
        [HttpDelete("DeleteUser/{UserId}", Name = "DeleteUser")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<UserDTO>> DeleteUser(int UserId)
        {
            if (UserId < 0)
            {
                return BadRequest("Invalid ID");
            }

            if (await UserService.DeleteUserAsync(UserId, _context))
            {
                return Ok($"Delete Is Successfully For User With ID -> {UserId}");
            }
            else
            {
                return NotFound($"Delete Is Not Successfully For User With ID -> {UserId} Or Not Found This User");
            }
        }

    }
}
