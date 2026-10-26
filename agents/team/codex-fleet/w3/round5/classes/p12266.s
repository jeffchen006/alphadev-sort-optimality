# n=5 model=out iset=I1 prefix14_class=12266
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovl S0, P1
cmp P2, P3
cmovge S1, P3
cmovg P3, P2
mov P1, S0
cmovg P2, S1
cmp S0, P2
cmovle S0, P2
cmovge P1, P2
mov P1, P0
cmovg P2, S0
