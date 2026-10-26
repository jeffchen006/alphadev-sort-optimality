# n=5 model=out iset=I1 prefix14_class=13096
cmp P1, P3
cmovge S2, P1
cmovl S2, P3
cmovg P1, P3
cmp P0, P2
mov P3, P2
cmovge P3, P0
cmovg P0, P2
mov P2, S2
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
mov P0, P1
