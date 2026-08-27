using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

// This authorization handler enforces the ownership rule for student resources.
// It checks whether the current user is either:
// - An Admin (full access), OR
// - The owner of the student record being requested
public class UserOwnerOrAdminHandler
    : AuthorizationHandler<UserOwnerOrAdminRequirement, int>
{
    protected override Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        UserOwnerOrAdminRequirement requirement,
        int Id)
    {
        // Admin override
        if (context.User.IsInRole("Admin"))
        {
            context.Succeed(requirement);
            return Task.CompletedTask;
        }

        // Ownership check
        var userId = context.User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (int.TryParse(userId, out int authenticatedUserId) &&
            authenticatedUserId == Id)
        {
            context.Succeed(requirement);
        }

        return Task.CompletedTask;
    }
}
