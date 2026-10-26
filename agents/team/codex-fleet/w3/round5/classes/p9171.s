# n=5 model=out iset=I1 prefix14_class=9171
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovge P1, P2
cmp P0, P3
mov P2, P3
cmovl P3, P0
cmovl P0, P2
cmp P3, S0
cmovge S2, P3
cmovg P3, S0
cmovg S0, S2
mov P3, P1
cmp P0, P3
