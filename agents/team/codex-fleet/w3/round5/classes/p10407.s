# n=5 model=out iset=I1 prefix14_class=10407
mov S0, P3
mov S1, P1
cmp P1, P0
cmovle P1, P0
cmovl P0, S1
cmp P2, S0
cmovg P3, P2
cmovle S0, P2
cmp P1, P3
cmovg S1, P1
cmovge P1, P3
cmovg P3, S1
cmp P0, S0
mov P3, P1
