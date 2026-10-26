# n=5 model=out iset=I1 prefix14_class=1573
cmp P0, P2
cmovg S1, P2
cmovg P2, P0
cmovle S1, P0
mov P0, P3
cmp P1, P3
cmovg P0, P1
cmovl P3, P1
cmp P3, S1
cmovg S0, S1
cmovle S0, P3
cmovg S1, P3
cmp P2, P0
cmovge S2, P0
