(** Base exception and helper functions. *)

(** Base exception, used everywhere. *)
exception Exc of string list

(** Raises an exception. *)
val throw : string -> 'a

(** Replaces an exception.

    If evaluation of the second argument fails, generates the exception composed of the first
    argument. *)
val erase_err : (unit -> string) -> (unit -> 'a) -> 'a

(** Chains an error to a trace of errors. *)
val chain_err : (unit -> string) -> (unit -> 'a) -> 'a

(** Catches an exception, prints it, and exits with code `2` *)
val catch_fail : (unit -> 'a) -> 'a