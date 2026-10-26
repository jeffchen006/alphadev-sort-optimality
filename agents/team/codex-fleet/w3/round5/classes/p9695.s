# n=5 model=out iset=I1 prefix14_class=9695
cmp P2, P1
cmovge S2, P2
cmovg P2, P1
cmovge P1, S2
mov S1, P3
cmp P0, S1
cmovle P3, P0
cmovge S1, P0
cmp S1, P1
cmovle P0, S1
cmovge P0, P1
cmovl S1, P1
mov S0, P0
cmp P2, P3
