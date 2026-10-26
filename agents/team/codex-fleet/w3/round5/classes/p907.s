# n=5 model=out iset=I1 prefix14_class=907
mov S1, P3
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmp P2, P0
mov P3, S1
mov S2, P2
cmovg P2, P0
cmovge P0, S2
cmp P0, P3
cmovg S1, P0
cmovl P3, P0
mov S1, P1
cmovge P0, P3
