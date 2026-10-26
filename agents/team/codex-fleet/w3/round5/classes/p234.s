# n=5 model=out iset=I1 prefix14_class=234
cmp P2, P0
mov S0, P2
mov S2, P3
cmovl S0, P0
cmovle P0, P2
cmp P3, P1
cmovg S2, P1
cmovge P1, P3
cmp S2, P0
mov P2, P0
cmovg P2, S2
cmovle P0, S2
cmp S0, P1
cmovg P3, S0
