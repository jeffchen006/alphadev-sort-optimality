# n=5 model=out iset=I1 prefix14_class=4455
cmp P2, P3
cmovg S1, P3
cmovge P3, P2
cmovg P2, S1
cmp P0, P1
mov S0, P1
cmovg S0, P0
mov S2, S0
cmovle P1, P0
cmp S2, P3
cmovl S0, P3
cmovle P3, S2
cmp P1, P2
mov S2, P1
