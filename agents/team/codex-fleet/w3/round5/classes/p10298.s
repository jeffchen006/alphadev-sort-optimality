# n=5 model=out iset=I1 prefix14_class=10298
cmp P1, P3
cmovle S0, P1
cmovl P1, P3
cmovge S0, P3
mov S1, P1
cmp P2, P0
cmovge P3, P0
cmovge P0, P2
cmovge P2, P3
cmp P0, S1
cmovg S1, P0
cmovle P1, P0
cmp P2, S0
mov P0, P1
