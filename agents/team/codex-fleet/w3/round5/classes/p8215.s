# n=5 model=out iset=I1 prefix14_class=8215
cmp P1, P0
cmovle S0, P0
cmovg S0, P1
cmovge P1, P0
cmp P2, P3
cmovle P0, P2
cmovle P2, P3
cmovl P3, P0
cmp P1, P3
mov S2, P2
cmovg S1, P3
cmovge P3, P1
cmovg P1, S1
mov S1, P3
