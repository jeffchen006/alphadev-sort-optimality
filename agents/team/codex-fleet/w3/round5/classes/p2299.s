# n=5 model=out iset=I1 prefix14_class=2299
mov S1, P3
cmp P3, P0
cmovge S1, P0
cmovle P3, P0
cmp P1, P2
mov P0, P1
cmovge P1, P2
cmovl P0, P2
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmovg S0, P0
cmp P1, S1
cmovle S0, P1
