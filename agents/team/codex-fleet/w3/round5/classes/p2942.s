# n=5 model=out iset=I1 prefix14_class=2942
mov S1, P1
cmp S1, P0
cmovg P1, P0
cmovg P0, S1
mov S2, P3
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
cmovg P3, S2
cmp P0, S2
cmovl S2, P0
cmovl P0, P3
cmp P1, P2
mov P0, P2
