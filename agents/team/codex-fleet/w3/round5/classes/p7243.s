# n=5 model=out iset=I1 prefix14_class=7243
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
cmovle S1, P2
mov P2, P1
cmp P1, P3
cmovle P2, P3
cmovl P3, P1
mov P1, P3
cmp P3, S1
cmovle P1, S1
cmovge P3, S1
cmp P0, P2
cmovg S0, P2
