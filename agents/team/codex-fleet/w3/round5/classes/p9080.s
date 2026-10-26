# n=5 model=out iset=I1 prefix14_class=9080
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovle P0, S1
cmp P3, P1
cmovle S0, P3
cmovg S0, P1
cmovle P3, P1
cmp P0, S0
mov P1, P0
cmovge P0, S0
cmovle P1, S0
cmp P3, P2
cmovge P0, P2
