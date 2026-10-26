# n=5 model=out iset=I1 prefix14_class=2853
mov S0, P3
cmp P3, P0
cmovg P3, P0
cmovle S0, P0
mov P0, P2
cmp P0, P1
cmovle P2, P1
cmovg P0, P1
mov P1, S0
cmp P2, S0
cmovg P1, P2
cmovg P2, S0
mov P1, P3
cmp P1, P0
