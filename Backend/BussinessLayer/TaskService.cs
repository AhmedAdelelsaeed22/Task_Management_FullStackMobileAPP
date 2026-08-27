using DataAccessLayer;
using DataAccessLayer.Data;
using DataAccessLayer.DTOs;

namespace BussinessLayer
{
    public class TaskService
    {
        public enum enMode { Insert = 0, Update = 1 }
        public enMode Mode = enMode.Insert;



        public TaskDTO TDTO
        {
            get
            {
                return (new TaskDTO(
                    this.task_id,
                    this.user_id,

                    this.status_id,
                    this.priority_id,
                    this.title,
                    this.description,
                    this.estimate_hours,
                    this.creation_date,
                    this.last_update_date,
                    this.completion_date));
            }
        }

        public int task_id { get; set; }

        public int user_id { get; set; }



        public int status_id { get; set; }

        public int priority_id { get; set; }

        public string title { get; set; } = null!;

        public string? description { get; set; }

        public decimal? estimate_hours { get; set; }


        public DateTime creation_date { get; set; }

        public DateTime last_update_date { get; set; }

        public DateTime? completion_date { get; set; }


        public TaskService(TaskDTO TDTO, enMode eMode = enMode.Insert)
        {
            this.task_id = TDTO.task_id;
            this.user_id = TDTO.user_id;

            this.status_id = TDTO.status_id;
            this.priority_id = TDTO.priority_id;
            this.title = TDTO.title;
            this.description = TDTO.description;
            this.estimate_hours = TDTO.estimate_hours;
            this.creation_date = TDTO.creation_date;
            this.last_update_date = TDTO.last_update_date;
            this.completion_date = TDTO.completion_date;

            Mode = eMode;
        }


        public static async Task<List<TaskDTO>> GetAllTasksForUserAsync(int userId, ApplicationDbContext context)
        {
            return await TaskData.GetAllTasksForUserAsync(userId, context);
        }


        public static async Task<TaskService?> FindAsync(int TaskId, ApplicationDbContext context)
        {
            TaskDTO? TaskDTO = await TaskData.GetTaskByIdAsync(TaskId, context);

            if (TaskDTO == null)
                return null;

            return new TaskService(TaskDTO, enMode.Update);
        }


        private async Task<bool> _InsertTaskAsync(ApplicationDbContext context)
        {
            this.task_id = await TaskData.CreateTaskAsync(TDTO, context);

            return this.task_id != 0;
        }


        private async Task<bool> _UpdateTaskAsync(ApplicationDbContext context)
        {
            return await TaskData.UpdateTaskAsync(TDTO, context);
        }


        public static async Task<bool> DeleteTaskAsync(int TaskId, ApplicationDbContext context)
        {
            return await TaskData.DeleteTaskAsync(TaskId, context);
        }


        public static async Task<bool> CompletedTaskAsync(int TaskId, ApplicationDbContext context)
        {
            return await TaskData.CompletedTaskAsync(TaskId, context);
        }

        public async Task<bool> Save(ApplicationDbContext context)
        {
            switch (Mode)
            {
                case enMode.Insert:
                    if (await _InsertTaskAsync(context))
                    {
                        Mode = enMode.Update;
                        return true;
                    }
                    else
                    {
                        return false;
                    }

                case enMode.Update:
                    return await _UpdateTaskAsync(context);
            }

            return false;
        }
    }
}