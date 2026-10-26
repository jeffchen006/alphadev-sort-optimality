# n=5 model=out iset=I1 prefix14_class=4177
mov S1, P1
cmp P2, S1
cmovle S1, P2
cmovge P1, P2
cmp P3, P0
cmovle S2, P3
mov P2, S1
cmovle P3, P0
cmovle P0, S2
cmp P0, S1
cmovg P2, P0
cmovle S1, P0
mov P0, P3
cmp P0, P1
