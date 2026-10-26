# n=5 model=out iset=I1 prefix14_class=11757
mov S0, P2
cmp P2, P0
cmovg S0, P0
cmovge P0, P2
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
mov S2, P0
cmovle P3, S1
cmp P1, P0
cmovge P0, P1
cmovg P1, S2
cmp P3, S0
cmovge P0, P3
