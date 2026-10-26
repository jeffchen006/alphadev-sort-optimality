# n=5 model=out iset=I1 prefix14_class=8152
mov S2, P0
cmp P0, P1
cmovle S2, P1
cmovl P1, P0
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
cmovge P2, S0
mov P0, P2
cmp P1, P3
cmovle S1, P1
cmovg S1, P3
cmovg P3, P1
mov P1, P3
