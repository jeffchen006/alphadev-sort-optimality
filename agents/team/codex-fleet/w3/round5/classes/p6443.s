# n=5 model=out iset=I1 prefix14_class=6443
cmp P1, P2
mov S1, P0
mov S0, P2
cmovl S0, P1
cmovg P2, P1
cmp P3, S1
mov S2, P2
cmovg S1, P3
cmovle P0, P3
cmp S1, P2
cmovl P2, S1
cmovg S2, S1
mov S2, P2
cmp S0, P0
