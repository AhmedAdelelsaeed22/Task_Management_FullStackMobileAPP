using DataAccessLayer.Data;
using DataAccessLayer.DTOs;
using DataAccessLayer.DTOs.Auth;
using DataAccessLayer.Entities;
using DataAccessLayer.Hashing;
using DataAccessLayer.Utilities;
using Microsoft.EntityFrameworkCore;

namespace DataAccessLayer
{
    public class UserDataAccess
    {

        private static user? _loadDataForUser(UserDTO NewUserDTO)
        {
            if (!EmailValidating.IsValidEmail(NewUserDTO.email_address))
            {
                return null;
            }

            if (!PasswordValidating.IsValidPassword(NewUserDTO.password))
            {
                return null;
            }

            user NewUser = new user
            {
                full_name = NewUserDTO.full_name,
                user_name = NewUserDTO.user_name,
                email_address = NewUserDTO.email_address,
                password_hash = PasswordHasher.HashPassword(NewUserDTO.password),
                job_title = NewUserDTO.job_title,
                time_zone = NewUserDTO.time_zone,
                account_status = NewUserDTO.account_status,
                date_created = NewUserDTO.date_created,
                last_login_date = NewUserDTO.last_login_date,
                user_role = NewUserDTO.user_role,
            };

            return NewUser;
        }

        private static user _loadSignUpData(SignUpDTO SDTO)
        {
            user NewUser = new user
            {
                full_name = SDTO.full_name,
                user_name = SDTO.user_name,
                email_address = SDTO.email_address,
                password_hash = PasswordHasher.HashPassword(SDTO.password),
                job_title = SDTO.job_title,
                time_zone = DateTime.UtcNow.ToString(),
                account_status = "Active",
                date_created = DateTime.UtcNow,
                last_login_date = DateTime.UtcNow,
                user_role = "user",
            };

            return NewUser;
        }

        public static async Task<int> CreateUserAsync(UserDTO NewUserDTO, ApplicationDbContext context)
        {
            user? NewUser = _loadDataForUser(NewUserDTO);

            if (NewUser == null)
            {
                return -1;
            }

            await context.users.AddAsync(NewUser);

            await context.SaveChangesAsync();

            return NewUser.user_id;
        }


        public static async Task<List<UserDTO>> GetAllUsersAsync(ApplicationDbContext context)
        {
            return await context.users
                     .Select(u => new UserDTO
                       (
                           u.user_id,
                           u.full_name,
                           u.user_name,
                           u.email_address,
                           u.password_hash,
                           u.job_title,
                           u.time_zone,
                           u.account_status,
                           u.date_created,
                           u.last_login_date,
                           u.user_role
                           ))
                       .AsNoTracking()
                       .ToListAsync();
        }

        public static async Task<UserDTO?> GetUserByIdAsync(int userid, ApplicationDbContext context)
        {
            var entity = await context.users
                          .FirstOrDefaultAsync(u => u.user_id == userid);

            if (entity == null)
                return null;


            return UserDTO.ToDTO(entity);
        }


        public static async Task<int?> GetUserIdUsingEmailAsync(string email,
        ApplicationDbContext context)
        {

            if (!EmailValidating.IsValidEmail(email)) return null;

            int? userId = await context.users
           .Where(u => u.email_address == email)
           .Select(u => (int?)u.user_id)
           .FirstOrDefaultAsync();

            if (userId == null) return null;


            return userId;


        }


        private static void _UpdateNewData(UserDTO NewUserData, user OldDataBeforeUpdated)
        {

            if (!EmailValidating.IsValidEmail(NewUserData.email_address))
            {
                return;
            }

            if (!PasswordValidating.IsValidPassword(NewUserData.password))
            {
                return;
            }

            OldDataBeforeUpdated.full_name = NewUserData.full_name;
            OldDataBeforeUpdated.user_name = NewUserData.user_name;
            OldDataBeforeUpdated.email_address = NewUserData.email_address;
            OldDataBeforeUpdated.password_hash = PasswordHasher.HashPassword(NewUserData.password);
            OldDataBeforeUpdated.job_title = NewUserData.job_title;
            OldDataBeforeUpdated.time_zone = NewUserData.time_zone;
            OldDataBeforeUpdated.account_status = NewUserData.account_status;
            OldDataBeforeUpdated.date_created = NewUserData.date_created;
            OldDataBeforeUpdated.last_login_date = NewUserData.last_login_date;
            OldDataBeforeUpdated.user_role = NewUserData.user_role;
        }

        public static async Task<bool> UpdateUserAsync(UserDTO updatedUser, ApplicationDbContext context)
        {
            user? existingUser = await context.users
                                             .FirstOrDefaultAsync(u => u.user_id == updatedUser.user_id);

            if (existingUser == null)
                return false;

            _UpdateNewData(updatedUser, existingUser);

            await context.SaveChangesAsync();

            return true;
        }





        public static async Task<UserDTO?> UserLoginAsync(string EmailAddress, string Password, ApplicationDbContext context)
        {
            if (!EmailValidating.IsValidEmail(EmailAddress)) return null;

            if (!PasswordValidating.IsValidPassword(Password)) return null;

            var existingUser = await context.users
                .FirstOrDefaultAsync(u => u.email_address == EmailAddress);

            if (existingUser == null || existingUser.email_address != EmailAddress) return null;

            if (!PasswordHasher.VerifyPassword(Password, existingUser.password_hash)) return null;

            return UserDTO.ToDTO(existingUser);

        }


        public static async Task<bool> UserSignUpAsync(SignUpDTO SIDTO, ApplicationDbContext context)
        {
            if (!EmailValidating.IsValidEmail(SIDTO.email_address)) return false;

            if (!PasswordValidating.IsValidPassword(SIDTO.password)) return false;

            bool IsExist = context.users.Any(u => u.email_address == SIDTO.email_address);


            if (IsExist)
            {
                return false;
            }


            user NewUser = _loadSignUpData(SIDTO);


            await context.users.AddAsync(NewUser);

            await context.SaveChangesAsync();

            return true;

        }

        public static async Task<bool> DeleteUserAsync(int userid, ApplicationDbContext context)
        {
            await context.users
                 .Where(u => u.user_id == userid)
                 .ExecuteDeleteAsync();

            return true;
        }


        public static async Task<bool> AddRefreshTokenAsync(refresh_token RefreshToken, ApplicationDbContext context)
        {

            await context.refresh_tokens.AddAsync(RefreshToken);

            await context.SaveChangesAsync();

            return true;

        }

        public static async Task<user?> FindUserUsingEmailAsync(string Email, ApplicationDbContext context)
        {

            user? userData = context.users
                .FirstOrDefault(u => u.email_address == Email);

            if (userData != null)
            {
                return userData;
            }

            return null;

        }


        public static async Task<refresh_token?> FindRefreshTokenUsingUserIdAsync(int UserId, ApplicationDbContext context)
        {

            refresh_token? refrechTokenData = context.refresh_tokens
                .FirstOrDefault(t => t.user_id == UserId);

            if (refrechTokenData != null)
            {
                return refrechTokenData;
            }

            return null;

        }


        public static async Task<bool> ReplaceRefreshTokenAsync(refresh_token refrechTokenData, string newRefreshToken, ApplicationDbContext context)
        {

            refrechTokenData.refresh_token_hash = BCrypt.Net.BCrypt.HashPassword(newRefreshToken);
            refrechTokenData.expires_at = DateTime.UtcNow.AddDays(7);
            refrechTokenData.revoked_at = null;
            await context.SaveChangesAsync();
            return true;
        }


        public static async Task<bool> DeleteRefreshTokenAsync(int RefreshTokenId, ApplicationDbContext context)
        {
            await context.refresh_tokens
                 .Where(t => t.refresh_token_id == RefreshTokenId)
                 .ExecuteDeleteAsync();

            return true;
        }




    }
}
