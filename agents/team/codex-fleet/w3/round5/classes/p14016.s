# n=5 model=out iset=I1 prefix14_class=14016
cmp P0, P3
mov S0, P0
cmovg P0, P3
cmovg P3, S0
mov S0, P1
cmp S0, P2
cmovle S0, P2
cmovle P2, P1
cmp S0, P3
cmovg P1, S0
cmovg S0, P3
cmovg P3, P1
mov P3, P0
cmp P0, P2
