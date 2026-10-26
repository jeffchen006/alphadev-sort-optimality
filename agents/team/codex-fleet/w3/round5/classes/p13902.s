# n=5 model=out iset=I1 prefix14_class=13902
cmp P0, P3
cmovg S0, P3
cmovle S0, P0
mov S1, P1
cmovge P3, P0
cmp P2, S1
cmovge P1, P2
cmovge P2, S1
cmp P3, P1
cmovge S1, P1
cmovg P1, P3
cmovge P3, S1
cmp P2, S0
cmovl P0, P2
