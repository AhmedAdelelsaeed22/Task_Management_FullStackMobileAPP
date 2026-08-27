using DataAccessLayer;
using DataAccessLayer.Data;
using DataAccessLayer.DTOs;
using DataAccessLayer.DTOs.Auth;
using DataAccessLayer.Entities;

namespace BussinessLayer
{
    public class UserService
    {
        public enum enMode { Insert = 0, Update = 1 }
        public enMode Mode = enMode.Insert;



        public UserDTO UDTO
        {
            get { return (new UserDTO(this.user_id, this.full_name, this.user_name, this.email_address, this.password, this.job_title, this.time_zone, this.account_status, this.date_created, this.last_login_date, this.user_role)); }
        }

        public int user_id { get; set; }

        public string full_name { get; set; } = null!;

        public string user_name { get; set; } = null!;

        public string email_address { get; set; } = null!;

        public string password { get; set; } = null!;



        public string? job_title { get; set; }

        public string? time_zone { get; set; }

        public string account_status { get; set; } = null!;

        public DateTime? date_created { get; set; }

        public DateTime last_login_date { get; set; }

        public string user_role { get; set; } = null!;

        public UserService(UserDTO UDTO, enMode eMode = enMode.Insert)
        {
            this.user_id = UDTO.user_id;
            this.full_name = UDTO.full_name;
            this.user_name = UDTO.user_name;
            this.email_address = UDTO.email_address;
            this.password = UDTO.password;

            this.job_title = UDTO.job_title;
            this.time_zone = UDTO.time_zone;
            this.account_status = UDTO.account_status;
            this.date_created = UDTO.date_created;
            this.last_login_date = UDTO.last_login_date;
            this.user_role = UDTO.user_role;

            Mode = eMode;


        }


        public static async Task<List<UserDTO>> GetAllUsersAsync(ApplicationDbContext context)
        {
            return await UserDataAccess.GetAllUsersAsync(context);
        }


        public static async Task<UserService?> FindAsync(int userId, ApplicationDbContext context)
        {
            UserDTO? userDTO = await UserDataAccess.GetUserByIdAsync(userId, context);

            if (userDTO == null)
                return null;


            return new UserService(userDTO, enMode.Update);
        }


        private async Task<bool> _InsertUserAsync(ApplicationDbContext context)
        {
            this.user_id = await UserDataAccess.CreateUserAsync(UDTO, context);
            return this.user_id != 0;
        }

        private async Task<bool> _UpdateUserAsync(ApplicationDbContext context)
        {
            return await UserDataAccess.UpdateUserAsync(UDTO, context);
        }


        public static async Task<int?> GetUserIdUsingEmailAsync(string email,
       ApplicationDbContext context)
        {
            return await UserDataAccess.GetUserIdUsingEmailAsync(email, context);
        }


        public static async Task<UserDTO?> UserLoginAsync(string EmailAddress, string Password, ApplicationDbContext context)
        {
            return await UserDataAccess.UserLoginAsync(EmailAddress, Password, context);
        }

        public static async Task<bool> DeleteUserAsync(int userid, ApplicationDbContext context)
        {
            return await UserDataAccess.DeleteUserAsync(userid, context);
        }


        public async Task<bool> Save(ApplicationDbContext context)
        {
            switch (Mode)
            {
                case enMode.Insert:
                    if (await _InsertUserAsync(context))
                    {
                        Mode = enMode.Update;
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                case enMode.Update:
                    return await _UpdateUserAsync(context);
            }

            return false;
        }


        public static async Task<bool> AddRefreshTokenAsync(refresh_token RefreshToken, ApplicationDbContext context)
        {
            return await UserDataAccess.AddRefreshTokenAsync(RefreshToken, context);
        }


        public static async Task<user?> FindUserUsingEmailAsync(string Email, ApplicationDbContext context)
        {
            return await UserDataAccess.FindUserUsingEmailAsync(Email, context);
        }


        public static async Task<refresh_token?> FindRefreshTokenUsingUserIdAsync(int UserId, ApplicationDbContext context)
        {
            return await UserDataAccess.FindRefreshTokenUsingUserIdAsync(UserId, context);
        }

        public static async Task<bool> ReplaceRefreshTokenAsync(refresh_token refrechTokenData, string newRefreshToken, ApplicationDbContext context)
        {
            return await UserDataAccess.ReplaceRefreshTokenAsync(refrechTokenData, newRefreshToken, context);
        }

        public static async Task<bool> DeleteRefreshTokenAsync(int RefreshTokenId, ApplicationDbContext context)
        {
            return await UserDataAccess.DeleteRefreshTokenAsync(RefreshTokenId, context);
        }

        public static async Task<bool> UserSignUpAsync(SignUpDTO SIDTO, ApplicationDbContext context)
        {
            return await UserDataAccess.UserSignUpAsync(SIDTO, context);
        }
    }
}
