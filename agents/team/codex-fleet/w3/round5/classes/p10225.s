# n=5 model=out iset=I1 prefix14_class=10225
cmp P0, P2
cmovle S0, P0
cmovle P0, P2
mov S2, P3
cmovle P2, S0
cmp P1, S2
cmovge P3, P1
cmovg P1, S2
mov S2, P0
cmp P3, S2
cmovg S2, P3
cmovl P0, P3
cmp P2, P1
cmovle S1, P2
