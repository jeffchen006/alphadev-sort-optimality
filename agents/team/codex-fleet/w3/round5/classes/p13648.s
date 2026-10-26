# n=5 model=out iset=I1 prefix14_class=13648
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovg P2, S1
mov S0, P3
cmp S0, P1
cmovg P3, P1
cmovle S0, P1
cmp P3, P0
mov P1, P0
cmovl P0, P3
mov P0, P2
cmovge P1, P3
cmp S0, P2
