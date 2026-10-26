# n=5 model=out iset=I1 prefix14_class=8814
cmp P0, P1
mov S1, P1
mov S0, P2
cmovg S1, P0
cmovl P1, P0
cmp P2, P3
cmovge P2, P3
cmovge P3, S0
mov P0, S1
cmp P3, P0
cmovg P0, P3
cmovge P3, S1
cmp P2, P1
cmovle S0, P1
