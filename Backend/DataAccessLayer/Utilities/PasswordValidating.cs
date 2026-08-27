namespace DataAccessLayer.Utilities
{
    public class PasswordValidating
    {
        public static bool IsValidPassword(string Password)
        {
            if (string.IsNullOrWhiteSpace(Password))
                return false;

            if (Password.Length < 8)
            {
                return false;
            }

            return true;
        }
    }
}
