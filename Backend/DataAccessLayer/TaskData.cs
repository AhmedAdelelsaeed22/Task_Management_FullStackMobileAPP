using DataAccessLayer.Data;
using DataAccessLayer.DTOs;
using DataAccessLayer.Entities;
using Microsoft.EntityFrameworkCore;

namespace DataAccessLayer
{
    public class TaskData
    {

        private static task _loadDataForTask(TaskDTO NewTaskDTO)
        {
            task NewTask = new task
            {

                user_id = NewTaskDTO.user_id,
                status_id = NewTaskDTO.status_id,
                priority_id = NewTaskDTO.priority_id,
                title = NewTaskDTO.title,
                description = NewTaskDTO.description,
                estimate_hours = NewTaskDTO.estimate_hours,
                creation_date = NewTaskDTO.creation_date,
                last_update_date = NewTaskDTO.last_update_date,
                completion_date = NewTaskDTO.completion_date
            };

            return NewTask;
        }


        public static async Task<int> CreateTaskAsync(TaskDTO NewTaskDTO, ApplicationDbContext context)
        {
            task NewTask = _loadDataForTask(NewTaskDTO);

            await context.tasks.AddAsync(NewTask);

            await context.SaveChangesAsync();

            return NewTask.task_id;
        }


        public static async Task<List<TaskDTO>> GetAllTasksForUserAsync(
    int userId,
    ApplicationDbContext context)
        {
            return await context.tasks
                .Where(t => t.user_id == userId)
                .AsNoTracking()
                .Select(t => new TaskDTO
                (
                    t.task_id,
                    t.user_id,

                    t.status_id,
                    t.priority_id,
                    t.title,
                    t.description,
                    t.estimate_hours,
                    t.creation_date,
                    t.last_update_date,
                    t.completion_date
                ))
                .ToListAsync();
        }

        public static async Task<TaskDTO?> GetTaskByIdAsync(int TaskId, ApplicationDbContext context)
        {
            var entity = await context.tasks
                .FirstOrDefaultAsync(t => t.task_id == TaskId);

            if (entity == null)
                return null;

            return TaskDTO.ToDTO(entity);
        }


        private static void _UpdateNewData(TaskDTO NewTaskData, task OldDataBeforeUpdated)
        {

            OldDataBeforeUpdated.user_id = NewTaskData.user_id;
            OldDataBeforeUpdated.status_id = NewTaskData.status_id;
            OldDataBeforeUpdated.priority_id = NewTaskData.priority_id;
            OldDataBeforeUpdated.title = NewTaskData.title;
            OldDataBeforeUpdated.description = NewTaskData.description;
            OldDataBeforeUpdated.estimate_hours = NewTaskData.estimate_hours;
            OldDataBeforeUpdated.creation_date = NewTaskData.creation_date;
            OldDataBeforeUpdated.last_update_date = NewTaskData.last_update_date;
            OldDataBeforeUpdated.completion_date = NewTaskData.completion_date;
        }


        public static async Task<bool> UpdateTaskAsync(TaskDTO UpdatedTask, ApplicationDbContext context)
        {
            task? ExistingTask = await context.tasks
                .FirstOrDefaultAsync(t => t.task_id == UpdatedTask.task_id);

            if (ExistingTask == null)
                return false;

            _UpdateNewData(UpdatedTask, ExistingTask);

            await context.SaveChangesAsync();

            return true;
        }


        public static async Task<bool> CompletedTaskAsync(int TaskId, ApplicationDbContext context)
        {
            task? ExistingTask = await context.tasks
                .FirstOrDefaultAsync(t => t.task_id == TaskId);

            if (ExistingTask == null)
                return false;

            ExistingTask.status_id = 4;

            await context.SaveChangesAsync();
            return true;
        }

        public static async Task<bool> DeleteTaskAsync(int TaskId, ApplicationDbContext context)
        {
            await context.tasks
                .Where(t => t.task_id == TaskId)
                .ExecuteDeleteAsync();

            return true;
        }

    }
}