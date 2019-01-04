(* A context is what one gets from loading contracts and test cases. *)

open Base
open Common

type t = {
    contracts : Contract.t StrMap.t ;
    tests : Testcase.t list ;
}

let mk (contracts : Contract.t StrMap.t) (tests : Testcase.t list) : t = {
    contracts ; tests
}

let of_raw
    (contracts : Contract.t list)
    (tests : Testcase.t list)
    : t
=   
    let rec loop (map : Contract.t StrMap.t) (contracts : Contract.t list) : Contract.t StrMap.t =
        match contracts with
        | head :: contracts -> (
            let map, prev = StrMap.insert head.name head map in
            prev |> if_let_some (
                fun prev ->
                    let desc =
                        match head.Contract.source, prev.Contract.source with
                        | Source.File hd, Source.File pre -> (
                            if hd = pre then
                                sprintf "in file `%s`" hd
                            else
                                sprintf "in files `%s` and `%s`" hd pre
                        )
                        | Source.File file, Source.Stdin
                        | Source.Stdin, Source.File file ->
                            sprintf "in file `%s` and standard input" file
                        | Source.Stdin, Source.Stdin ->
                            "in standard input"
                    in
                    sprintf "there is at least two contracts named `%s` %s" head.name desc
                    |> Exc.throw
            );
            loop map contracts
        )
        | [] -> map
    in
    let contracts = loop StrMap.empty contracts in
    mk contracts tests

let get_contract (name : string) ({ contracts ; _ } : t) : Contract.t =
    Exc.erase_err (
        fun () -> sprintf "unknown contract `%s`" name
    ) (
        fun () -> StrMap.find name contracts
    )

let get_tests ({ tests ; _ } : t) : Testcase.t list = tests

let fmt ~(full : bool) (fmt : formatter) ({ contracts ; tests } : t) : unit =
    fprintf fmt "@[<v>";
    contracts |> StrMap.iter (
        fun _ contract ->
            Contract.fmt ~full fmt contract;
            fprintf fmt "@,"
    );
    tests |> List.iter (Testcase.fmt ~full fmt);
    fprintf fmt "@]"