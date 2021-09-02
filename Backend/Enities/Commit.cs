using System;
using System.ComponentModel.DataAnnotations;

namespace EventSourceDemo {
    public class Commit {
        [Key] public int order { get; private set; }

        /**
         * Type of Commits via nameof(ExampleCommitType)
         */
        [Required]
        public string type { get; set; } = null!;

        [Required] public string className { get; set; } = null!;

        [Required] public Guid objectId { get; set; } = Guid.Empty;

        [Required] public string payload { get; set; } = null!;
    }
}
