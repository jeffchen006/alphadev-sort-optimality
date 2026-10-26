# n=5 model=out iset=I1 prefix14_class=9172
cmp P2, P1
cmovle S0, P2
cmovge S0, P1
cmovge P1, P2
cmp P3, P0
mov P2, P0
cmovl P0, P3
cmovl P3, P2
cmp P0, S0
cmovge S2, P0
cmovg P0, S0
cmovg S0, S2
mov P0, P1
cmp P3, P0
