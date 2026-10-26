# n=5 model=out iset=I1 prefix14_class=6945
cmp P3, P2
cmovle S1, P2
cmovge S1, P3
cmovge P3, P2
cmp P1, P0
cmovl S0, P1
cmovge S0, P0
mov P2, S1
cmovg P0, P1
cmp P2, P0
cmovge P2, P0
cmovg P0, S1
mov P0, P3
cmovg S1, P2
