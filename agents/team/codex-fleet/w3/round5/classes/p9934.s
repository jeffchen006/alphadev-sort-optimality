# n=5 model=out iset=I1 prefix14_class=9934
cmp P2, P3
mov S1, P3
cmovle P3, P2
cmovg S1, P2
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
mov S2, S1
cmovg P0, P2
cmp S1, P0
cmovge S2, P0
cmovl S1, P0
cmp P3, P1
mov S1, S2
