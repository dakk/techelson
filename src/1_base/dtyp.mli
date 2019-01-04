(** Datatype types and helpers. *)

open Common

(** Nullary datatypes. *)
type leaf =
| Str
| Nat
| Int
| Bytes
| Bool
| Unit
| Mutez
| Address
| Operation
| Key
| KeyH
| Signature
| Timestamp

(** Formatter for nullary datatypes. *)
val fmt_leaf : formatter -> leaf -> unit

(** String to leaf conversion. *)
val leaf_of_string : string -> leaf option

(** Wraps a datatype with a name. *)
type named = {
    inner : t ;
    (** Actual datatype. *)
    name : Annot.Field.t option ;
    (** Field annotation. *)
}

(** Nameless datatype. *)
and dtyp =
| Leaf of leaf

| List of t
| Option of t
| Set of t
| Contract of t

| Pair of named * named
| Or of named * named
| Map of t * t
| BigMap of t * t

(** Datatypes. *)
and t = {
    typ : dtyp ;
    (** Actual datatype. *)
    alias : Annot.Typ.t option ;
    (** Type annotation. *)
}

(** Named datatype constructor. *)
val mk : ?alias : Annot.Typ.t option -> dtyp -> t

(** Named datatype constructor from a leaf. *)
val mk_leaf : ?alias : Annot.Typ.t option -> leaf -> t

(** Formatter for datatypes. *)
val fmt : formatter -> t -> unit

(** The unit type *)
val unit : t

(** The integer type. *)
val int : t

(** The natural type. *)
val nat : t

(** The timestamp type. *)
val timestamp : t

(** Type destructors. *)
module Inspect : sig
    (** Retrieves the two type parameters of a union type. *)
    val either : t -> t * t

    (** Retrieves the type parameter of an option type. *)
    val option : t -> t

    (** Retrieves the type parameter of a list type. *)
    val list : t -> t
end