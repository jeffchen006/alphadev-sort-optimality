# n=5 model=out iset=I1 prefix14_class=8096
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
cmovge S2, P0
cmp P2, P1
cmovg S1, P1
cmovge P1, P2
cmovg P2, S1
cmp P2, S2
cmovle S0, S2
cmovle S2, P2
mov S1, P1
cmovl P2, S0
cmp P3, S1
