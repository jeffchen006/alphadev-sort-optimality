# n=5 model=out iset=I1 prefix14_class=14170
mov S2, P3
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovl P0, S0
cmp P1, S2
cmovg S2, P1
cmovg P1, P3
cmp P0, S2
cmovg S1, P0
cmovge P0, S2
cmovg S2, S1
cmp P1, P2
cmovge P3, P2
