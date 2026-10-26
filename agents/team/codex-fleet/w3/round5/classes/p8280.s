# n=5 model=out iset=I1 prefix14_class=8280
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovle P3, S1
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovge P1, P2
cmp P0, S0
mov S1, S0
cmovg S1, P0
cmovge P0, S0
mov S0, S1
mov P0, P1
