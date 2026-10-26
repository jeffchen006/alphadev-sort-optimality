# n=5 model=out iset=I1 prefix14_class=5971
mov S0, P3
cmp P0, P3
cmovl S0, P0
cmovg P3, P0
mov S1, P1
cmp S1, P2
cmovl S1, P2
mov S2, P3
cmovge P1, P2
cmp S1, P3
cmovle P3, S1
cmovle S1, S2
cmp S0, P1
cmovge P0, P1
