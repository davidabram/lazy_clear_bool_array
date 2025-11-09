type t = {
  n : int;
  ts : int array;
  mutable cur : int;
}

let length a = a.n

let create n =
  if n < 0 then invalid_arg "Lazy_clear_bool_array.create: negative length";
  { n
  ; ts = Array.make n 0
  ; cur = 1
  }

let check_index a i =
  if i < 0 || i >= a.n then
    invalid_arg (Printf.sprintf "index out of bounds: %d (length %d)" i a.n)

let set a i b =
  check_index a i;
  if b then
    a.ts.(i) <- a.cur
  else
    a.ts.(i) <- a.cur - 1

let get a i =
  check_index a i;
  a.ts.(i) >= a.cur

let clear a =
  a.cur <- a.cur + 1


