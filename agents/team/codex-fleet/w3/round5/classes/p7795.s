# n=5 model=out iset=I1 prefix14_class=7795
mov S2, P0
cmp S2, P3
cmovl S2, P3
mov S0, P1
cmovle P3, P0
cmp S0, P2
cmovle P1, P2
cmovg S0, P2
cmp S0, P3
mov P2, P3
cmovle P3, S0
cmovg P2, S0
cmovle S0, P2
mov P3, P1
