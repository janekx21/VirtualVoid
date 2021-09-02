using System;
using System.ComponentModel.DataAnnotations;

namespace EventSourceDemo {
    public class User {
        [Key] public Guid id { get; set; } = Guid.NewGuid();
        [Required] public string userName { get; set; } = null!;
        [Required] public string firstName { get; set; } = null!;
        [Required] public string lastName { get; set; } = null!;
    }
}
