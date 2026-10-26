# n=5 model=out iset=I1 prefix14_class=9740
cmp P2, P3
mov S1, P0
cmovg S0, P3
cmovge P3, P2
cmovle S0, P2
cmp P1, P0
cmovle P0, P1
cmovle P1, S1
cmp P3, P1
cmovge S1, P3
mov P2, P0
cmovg P3, P1
cmovg P1, S1
mov P1, P3
