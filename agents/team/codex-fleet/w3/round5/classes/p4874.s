# n=5 model=out iset=I1 prefix14_class=4874
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
cmovle S1, P2
mov P2, P0
cmp P3, P2
cmovle P2, P3
cmovg P0, P3
cmp P2, S1
mov P3, P2
cmovle P3, S1
cmovg P2, S1
cmp P1, P0
cmovg S0, P1
