using System;
using System.ComponentModel.DataAnnotations;

namespace EventSourceDemo {
    public class Commit {
        public Commit(string type, string className, Guid objectId, string payload) {
            this.type = type;
            this.className = className;
            this.objectId = objectId;
            this.payload = payload;
        }

        [Key] public int order { get; private set; }

        /**
         * Type of Commits via nameof(ExampleCommitType)
         */
        [Required]
        public string type { get; set; }

        [Required] public string className { get; set; }
        [Required] public Guid objectId { get; set; }
        [Required] public string payload { get; set; }
    }
}
