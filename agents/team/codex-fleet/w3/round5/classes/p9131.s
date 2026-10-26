# n=5 model=out iset=I1 prefix14_class=9131
mov S0, P2
cmp P2, P3
cmovle P2, P3
cmovg S0, P3
cmp P0, P1
cmovge S1, P0
mov P3, S0
cmovg P0, P1
cmovge P1, S1
cmp P0, S0
mov S2, P2
cmovle S0, P0
cmovl P0, P3
mov S0, P0
