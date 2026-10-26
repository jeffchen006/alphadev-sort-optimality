# n=5 model=out iset=I1 prefix14_class=7375
cmp P1, P3
mov S2, P1
cmovle P1, P3
cmovl P3, S2
cmp P2, P0
cmovg S1, P0
mov S0, P3
cmovle S1, P2
cmovg P0, P2
cmp P3, S1
cmovge P3, S1
cmovle S0, S1
cmp P1, P0
mov P3, S0
