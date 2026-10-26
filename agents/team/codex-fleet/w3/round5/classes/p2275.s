# n=5 model=out iset=I1 prefix14_class=2275
cmp P3, P2
cmovg S1, P2
mov S0, P0
cmovle S1, P3
cmovl P3, P2
cmp P0, P1
cmovle S0, P1
cmovg P0, P1
cmp P3, S0
mov P1, S0
cmovle S0, P3
cmovge P1, P3
cmp P0, S1
cmovle P3, S1
