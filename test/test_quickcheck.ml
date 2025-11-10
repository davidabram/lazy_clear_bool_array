open Core

module A = Bool_vector.Lazy_clear_bool_array

module Operation = struct
  type t =
    | Set of bool
    | Get
    | Clear
  [@@deriving quickcheck]
end

let execute_step ~(model : bool array) ~(impl : A.t) (op, idx) =
  match (op : Operation.t) with
  | Set v ->
      model.(idx) <- v;
      A.set impl idx v
  | Get ->
      assert (Bool.equal model.(idx) (A.get impl idx))
  | Clear ->
      Array.fill model ~pos:0 ~len:(Array.length model) false;
      A.clear impl

let () =
  let open Quickcheck.Generator.Let_syntax in
  let gen =
    let%bind n = Int.gen_incl 1 20 in
    let%map steps =
      Quickcheck.Generator.list
        (let%map op = Operation.quickcheck_generator
         and idx = Int.gen_incl 0 (n - 1) in
         (op, idx))
    in
    (n, steps)
  in
  Quickcheck.test gen ~f:(fun (n, steps) ->
      let model = Array.create ~len:n false in
      let impl = A.create n in
      List.iter steps ~f:(execute_step ~model ~impl));
  print_endline "QuickCheck tests passed: Lazy_clear_bool_array matches model behavior"
