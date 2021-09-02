using GraphQL.Types;
using VirtualVoid.Model;

namespace VirtualVoid {
    public sealed class BoardInput : InputObjectGraphType<Types.BoardInput> {
        public BoardInput() {
            Field(o => o.name);
        }
    }
}
