define puts
  echo '
  set $c = $arg0
  while (*$c != 0)
    printf "%c", *$c
    set $c++
  end
  echo '\n
end

define st
  if ($arg0 != 0)
    call $arg0->showTreeForThis()
  end 
end

define sts
  call $arg0.showTreeForThis()
end
