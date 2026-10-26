# n=5 model=out iset=I1 prefix14_class=2614
cmp P3, P2
cmovge S2, P2
cmovg P2, P3
cmovg P3, S2
cmp P0, P1
mov S1, P2
cmovle S0, P1
cmovg S0, P0
cmovg P0, P1
cmp S0, S1
mov P1, P0
cmovl S1, S0
cmovle S0, P2
mov P2, S1
